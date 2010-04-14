#!/usr/bin/perl -w

#
#  "the Modulator" - sounds sinister, doesn't it?
#
#  DON'T REPEAT YOURSELF or "DRY"
#
# "Every piece of knowledge must have a single, unambiguous, authoritative
#  representation within a system."
#
#    - Andy Hunt & Dave Thomas, "The Pragmatic Programmer", p.27
#
#   This is a great principle to follow, as it saves headache and time.
# With this program, I've attempted to eliminate a lot of the repetitive work
# involved in creating Drupal modules.  In addition, I've provided a means to
# generate stub test code for use with the SimpleTest module.  The goals of
# this code are two-fold
#
# 1) lower the barrier to entry for having modules tested by their authors
# 2) eliminate errors in repetitive code by generating it
#
# The program began as two separate scripts.  One to generate module code
# and another to setup test stubs. Additionally, the test stubs were created
# for PHPUnit.  Though PHPUnit seems more complete, I felt it was in the best
# interest of the comunity to stick to SimpleTest.
# I eventually consolidated them and refined them into this script,
# which I dubbed, "the Modulator". Yes, I'm a dork.
#
# This code is far from complete, but I wanted to release it as early
# as possible to the community to allow others to improve what I've begun.
# If you see something here that violates DRY, or could otherwise use
# improvement, please refactor it! Finally, there are most certainly bugs.
# Please report them.
#
# Features:
#   - creates a module folder and associated file skeletons
#   - generates a test class and test methods and places them in a test file
#     recognized by SimpleTest.  This currently only covers unit tests,
#     and not higher level tests like functional or integration tests.
#   - can be re-run throughout module development
#     - if you add a new function to a module, rerun the script and a test
#       stub will be generated and placed in the appropriate test class
#   - works with existing modules
#     - adds hook_simpletest to an existing module
#
# Issues:
#   - test stubs intentionally fail.  I tried replicating PHPUnit's
#       TestNotImplementedException, but I didn't find a similar facility
#
# Assumptions:
#  - the drupal coding standard is followed (generally, 1 tab == 2 spaces)
#  - a single module is defined per directory
#    - the module has the same name as the directory
#
# Features Not Included:
#  - getters and setters for classes defined in module file
#  - class handling in general is not working, but the basic code is in place
# 
# TODO:
#  - complete handling for classes
#  - add handling for function removal by developer
#  - make template variables files - is this necessary?
#  - create CRUD scaffolds a la Ruby on Rails
#  - improve test coverage to include suites and further automation
#
# lovingly crafted by Andy Michaels amichaels@achieveinternet.com
#

use strict;
use warnings;
use Tie::File;
use List::Util qw(first);

my $usage = "usage: ./Modulator.pl module_name [\"group name\"] [tab_width]\n";
my $numArgs = 0;
my $moduleName = '';            # system-readable version
my $niceModuleName = '';        # human-readable version
my $group = "Contributed";      # group name for unit testing info
my $tab = '  ';                 # a single tab's worth of spaces
my $infoFileName = '';          # name+ext used for the .info file
my $installFileName = '';       # name+ext used for the .install file
my $moduleFileName = '';        # name+ext used for the .module file
my $testFileName = '';          # name+ext used for the test file
my @infoFile;                   # array to mirror .info file
my @installFile;                # array to mirror .install file
my @moduleFile;                 # array to mirror modulef file
my @testFile;                   # array to mirror test file
my $inClass = 0;                # is the current line within a class def?
my $class = '';                 # holds a single class record
my @classes;                    # stores all class info
my $className = 'empty';        # name of a single class
my @attribs;                    # stores a class' attribute names
my @methods;                    # stores a class' method names
my @newFuncs;                   # stores the newly found functions

my $rec = {                     # info for a single class
    NAME      => $className,
    ATTRIBS   => [ @attribs ],
    METHODS   => [ @methods ],
};
my @funcs;                      # stores function names not defined in classes
my $func;                       # a single function in the list

#
# input handling : this has to happen before the next set of variables
# are defined.
#
$numArgs = @ARGV;
if ($numArgs == 0) {
    die "too few parameters:\n$usage";
}

if (@ARGV >= 1) {
    # sanity check the input module name
    # strip trailing slash
    $moduleName = $ARGV[0];
    $moduleName =~ s/\/$//;
    $niceModuleName = $moduleName;
    # replace '_' with a space
    $niceModuleName =~ s/_/ /g;
    # and capitalize the words
    $niceModuleName =~ s/\b(\w)/\U$1/g;
    $moduleFileName = $moduleName.'.module';
    $installFileName = $moduleName.'.install';
    $infoFileName = $moduleName.'.info';
    $testFileName = $moduleName.'.test';
}

if ($numArgs >= 2) {
    $group = $ARGV[1];
}

if ($numArgs >= 3) {
    $tab = '';
    my $i =0;
    for($i = 0; $i < $ARGV[2]; $i++) {
        $tab .= " ";
    }
}

if ($numArgs > 3) {
    die "too many parameters:\n$usage\n";
}

#
# The following variables are the templates for the various files we create
# at some point, I may move these to actual files that are read in
# and just do variable replacement
#
my $installContents = 
    "\<\?php\n".
    "\/\/\$Id\$\n\n".
    "\/\*\*\n".
    " \*  Implementation of hook_install\(\)\.\n".
    " \*\/\n\n".
    "function $moduleName"."_install\(\) \{\n".
    $tab."drupal_set_message\(t\(\'Beginning installation of the $moduleName ".
    "module\.\'\)\)\;\n".
    $tab."switch\(\$GLOBALS\[\'db_type\'\]\) \{\n".
    $tab.$tab."case \'mysql\'\:    \/\/ use same as mysqli\n".
    $tab.$tab."case \'mysqli\'\:\n".
    $tab.$tab.$tab."\/\/db_query\(\"CREATE TABLE \{\} \(\n".
    $tab.$tab.$tab.
      "\/\/\) \/\*\!40100 DEFAULT CHARACTER SET UTF8 \*\/ \"\)\;\n".
    $tab.$tab.$tab."\$success \= TRUE\;\n".
    $tab.$tab.$tab."break\;\n".
    $tab.$tab."case \'pgsql\'\:\n".
    $tab.$tab.$tab."break\;\n".
    $tab.$tab."default\:\n".
    $tab.$tab.$tab."drupal_set_message\(t\(\'Unsupported Database\.\'\)\)\;\n".
    $tab.$tab."break\;\n".
    $tab."\}\n".
    $tab."if\(\$success\) \{\n".
    $tab.$tab."drupal_set_message\(t\(\'The $moduleName module installed ".
    "successfully\'\)\)\;\n".
    $tab."\}\n".
    $tab."else \{\n".
    $tab.$tab."drupal_set_message\(t\(\'The $moduleName module installation".
    "failed\.\'\)\,\n".
    $tab.$tab.$tab."\'error\'\)\;\n".
    $tab."\}\n".
    "\}\n\n".
    "\/\*\*\n".
    " \*  Implementation of hook_uninstall\(\)\.\n".
    " \*\/\n".
    "function $moduleName"."_uninstall\(\) \{\n".
    $tab."\/\/db_query\(\"DROP TABLE \{\}\"\)\;\n".
    $tab."\/\/variable_del\(\'$moduleName"."_nodetypes\'\)\;\n".
    "\}\n";
my $infoContents =
    "\; \$Id\$\n\n".
    "name \= \"$niceModuleName\"\n".
    "description \= \n".
    "package \= \"$group\"\n".
    "version \= \"\&alpha\;\"\n";
my $moduleContents =
    "\<\?php\n".
    "\/\/ \$Id\$\n".
    "\n".
    "\/\*\*\n".
    " \*  \@file $moduleName".".module\n".
    " \*  lovingly crafted by \n".
    " \*\/\n".
    "\n".
    "\/\*\*\n".
    " \*  Drupal Hook implementations\n".
    " \*\/\n".
    "\n".
    "\/\*\*\n".
    " \*  implementation of hook\_user\(\)\n".
    " \*\/\n".
    "function $moduleName"."\_user\(\$op\, \&\$edit\, \&\$user\, ".
    "\$category \= NULL\) \{\n".
    $tab."global \$user\;\n".
    $tab."switch \(\$op\) \{\n".
    $tab.$tab."case \'login\'\:\n".
    $tab.$tab.$tab."break\;\n".
    $tab."\}\n".
    "\}\n".
    "\n".
    "\/\*\*\n".
    " \*  implementation of hook\_menu\(\)\n".
    " \*\/\n".
    "function $moduleName\_menu\(\$may\_cache\) \{\n".
    $tab."\$items \= array\(\)\;\n".
    $tab."if \(\!\$may\_cache\) \{\n".
    $tab.$tab."\$items\[\] \= array\(\n".
    $tab.$tab.$tab."\'path\' \=\> \'admin\/settings\/".$moduleName."\'\,\n".
    $tab.$tab.$tab."\'title\' \=\> t\(\'TEXT\'\)\,\n".
    $tab.$tab.$tab."\'description\' \=\> t\(\'TEXT\'\)\,\n".
    $tab.$tab.$tab."\'callback\' \=\> \'drupal\_get\_form\'\,\n".
    $tab.$tab.$tab."\'callback arguments\' \=\> array\(\'".$moduleName.
    "\_admin\_settings\'\)\,\n".
    $tab.$tab.$tab."\'access\' \=\> user\_access\(\'administer ".
    "site configuration\'\)\n".
    $tab.$tab."\)\;\n".
    $tab.$tab."\$items\[\] \= array\(\n".
    $tab.$tab.$tab."\'path\' \=\> \'node\/add\/".$moduleName."\'\,\n".
    $tab.$tab.$tab."\'title\' \=\> t\(\'TEXT\'\)\,\n".
    $tab.$tab.$tab."\'access\' \=\> user\_access\(\'TEXT\'\)\n".
    $tab.$tab."\)\;\n".
    $tab."\}\n".
    $tab."return \$items\;\n".
    "\}\n".
    "\n".
    "\/\*\*\n".
    " \*  implementation of hook\_admin\_settings\(\)\n".
    " \*\/\n".
    "function $moduleName"."\_admin\_settings\(\) \{\n".
    $tab."drupal\_set\_message\(t\(\'nothing to do here yet\'\)\)\;\n".
    "\}\n".
    "\n".
    "\/\*\*\n".
    " \*  implementation of hook\_perm \n".
    " \*\/\n".
    "function $moduleName"."\_perm\(\) \{\n".
    $tab."return array\(\'TEXT\'\, \'TEXT\'\)\;\n".
    "\}\n".
    "\n".
    "\/\*\*\n".
    " \* implementation of hook\_access\(\)\n".
    " \*\/\n".
    "function $moduleName"."\_access\(\$op\, \$node\) \{\n".
    $tab."global \$user\;\n".
    $tab."\n".
    $tab."switch \(\$op\) \{\n".
    $tab.$tab."case \'create\'\:\n".
    $tab.$tab.$tab."return user\_access\(\'TEXT\'\)\;\n".
    $tab.$tab.$tab."break\;\n".
    $tab.$tab."case \'update\'\: \/\/same as delete\n".
    $tab.$tab."case \'delete\'\:\n".
    $tab.$tab.$tab."return user\_access\(\'TEXT\'\)\n".
    $tab.$tab.$tab.$tab."\&\& \(\$user\-\>uid \=\= \$node\-\>uid\)\;\n".
    $tab.$tab.$tab."break\;\n".
    $tab."\}\n".
    "\}\n".
    "\n".
    "\/\*\*\n".
    " \* implementation of hook\_node\_info\(\)\n".
    " \*\/\n".
    "function $moduleName"."\_node\_info\(\) \{\n".
    "\}\n".
    "\n".
    "\/\*\*\n".
    " \* implementation of hook\_form\(\)\n".
    " \* \@param \: \$node\n".
    " \*\/\n".
    "function $moduleName"."\_form\(\$node\) \{\n".
    $tab."\$type \= node\_get\_types\(\'type\'\, \$node\)\;\n".
    $tab."return \$form\;\n".
    "\}\n".
    "\n".
    "\/\*\*\n".
    " \*  implementation of hook\_insert\(\)\n".
    " \*\/\n".
    "function $moduleName"."\_insert\(\$node\) \{\n".
    $tab."global \$user\;\n".
    "\}\n".
    "\n".
    "\/\*\*\n".
    " \* implementation of hook\_update\(\)\n".
    " \*\/\n".
    "function $moduleName"."\_update\(\$node\) \{\n".
    $tab."if \(\$node\-\>revision\) \{\n".
    $tab.$tab."$moduleName"."\_insert\(\$node\)\;\n".
    $tab."\}\n".
    "\n".
    $tab."else \{\n".
    $tab."\}\n".
    "\}\n".
    "\n".
    "\/\*\*\n".
    " \*  implementation of hook\_delete\(\)\n".
    " \*\/\n".
    "function $moduleName"."\_delete\(\&\$node\) \{\n".
    "\}\n".
    "\n".
    "\/\*\*\n".
    " \*  implementation of hook\_load\(\)\n".
    " \*\/\n".
    "function $moduleName"."\_load\(\$node\) \{\n".
    "\}\n".
    "\n".
    "\/\*\*\n".
    " \*  implementation of hook\_view\(\)\n".
    " \*\/\n".
    "function $moduleName"."\_view\(\$node\, \$teaser \= FALSE\, ".
    "\$page \= FALSE\) \{\n".
    $tab."\$node \= node\_prepare\(\$node\, \$teaser\)\;\n".
    $tab."if \(\!\$teaser\) \{\n".
    $tab."\}\n".
    $tab."return \$node\;\n".
    "\}\n".
    "\n".
    "\/\*\*\n".
    " \* implementation of hook\_block\(\)\n".
    " \*\/\n".
    "function $moduleName"."\_block\(\$op \= \'list\'\, \$delta ".
    "\= 0\, \$edit \= array\(\)\) \{\n".
    $tab."switch \(\$op\) \{\n".
    $tab."case \'list\'\:\n".
    $tab.$tab."return \$blocks\;\n".
    $tab.$tab."\/\/break\;\n".
    $tab."case \'configure\'\:\n".
    $tab.$tab."\/\/break\;\n".
    $tab."case \'save\'\:\n".
    $tab.$tab."break\;\n".
    $tab."case \'view\'\:\n".
    $tab.$tab."return \$block\;\n".
    $tab.$tab."\/\/break\;\n".
    $tab."\}\n".
    "\}\n\n";
my $simpletest =
    "\/\*\*\n".
    "\*  Implementation of hook\_simpletest\(\)\.\n".
    "\*\/\n".
    "function $moduleName"."\_simpletest\(\) \{\n".
    "$tab\$module\_name \= \'$niceModuleName\'\;\n".
    "$tab\$dir \= drupal\_get\_path\(\'module\'\, \'$moduleName".
    "\'"."\)\. \'\/tests\'\;\n".
    "$tab\$tests \= file\_scan\_directory\(\$dir\, \'\\\.test\$\'\)\;\n".
    "$tab"."return array\_keys\(\$tests\)\;\n".
    "\}\n";
my $testContents = 
    "\<\?php\n".
    "class $moduleName"."Test extends DrupalTestCase \{\n".
    $tab."\/\*\*\n".
    $tab." \*  here there be fixtures\n".
    $tab." \*\/\n".
    "\n".
    $tab."function get\_info\(\) \{\n".
    $tab.$tab."return array\(\n".
    $tab.$tab.$tab."\'name\' \=\> t\(\'$moduleName Unit Tests\'\)\,\n".
    $tab.$tab.$tab."\'desc\' \=\> t\(".
      "\'tests the unit functions of the $moduleName module'\)\,\n".
    $tab.$tab.$tab."\'group\' \=\> t\(\'$group\: ".
    "$moduleName module\'\)\,\n".
    $tab.$tab."\)\;\n".
    $tab."\}\n".
    "\n".
    $tab."\/\*\*\n".
    $tab." \* setUp and tearDown functions to configure the fixtures\n".
    $tab." \*\/\n".
    $tab."public function setUp\(\) \{\n".
    $tab."\}\n".
    $tab."\n".
    $tab."public function tearDown\(\) \{\n".
    $tab."\}\n".
    "\}\n".
    "\?\>\n";

#
# creates a new testfile in module/tests
#
sub createTestFile {
    # let's try putting it all in one file...
    tie @testFile, 'Tie::File', "$moduleName/tests/$moduleName.test" or
        die "Can't open $moduleName/tests/$moduleName.test : $!";
    push(@testFile, $testContents);
    untie @testFile;
}

#
# creates the 3 new drupal-specific files for the named module
#
sub createModuleFiles {
    if(!-e $moduleName."/".$moduleFileName) {
        tie @moduleFile, 'Tie::File', "$moduleName/$moduleFileName" or
            die "Can't open $moduleFileName : $!";
    }
    
    if(!-e $moduleName."/".$installFileName) {
        tie @installFile, 'Tie::File', "$moduleName/$installFileName" or
            die "Can't open $installFileName : $!";
    }
    
    if(!-e $moduleName."/".$infoFileName) {
        tie @infoFile, 'Tie::File', "$moduleName/$infoFileName" or
            die "Can't open $infoFileName : $!";
    }    
    push @installFile, $installContents;
    push @infoFile, $infoContents;
    push @moduleFile, $moduleContents;
    push @moduleFile, $simpletest;
    
    untie @moduleFile;
    untie @installFile;
    untie @infoFile;
}

#
# outputs function test stubs to the test file
#
sub createFuncTestStub {
    my $item = shift;
    return "$tab\/**\n"
           . $tab." *  this method tests $item\n"
           . $tab." */\n"
           . "$tab"."public function test_$item\(\) \{\n"
           . "$tab$tab"
           . "\$this-\>assertFalse(1)\;\n"
           . "$tab$tab"
           . "\/\/ the test intentionally fails until you supply good code"
           . "\n"
           . "$tab}\n";
}

#
# passed a class name and a file array, return the array index where
# new functions can be inserted into the array. new functions will be inserted
# on the line just before the ending "}"
#
sub getInsertIndex($ \@) {
    my $found = 0;
    my $i = 0;
    my $insert = -1;
    my $className = shift;
    my $fileArray = shift;
    for($i = 0; $i < @$fileArray; $i++ ) {
        if((@$fileArray[$i] =~ /^class ($moduleName)Test/)) {
    	      $found = 1;
        }
        if((@$fileArray[$i] eq "}") && ($found)) {
            $insert = $i - 1;
            $found = 0;
            last;
        }
    }
    return $insert; 
}

# if, for some reason, the files do not already exist (someone deleted then)
# then we do not need to worry about Tie:File, since it will create the file
# and nothing will be bad.

#
# create the folders and files for the module if they don't already exist
#
if(!-e $moduleName) {
    mkdir $moduleName;
} else {
    print "Module folder already exists, checking for module files\n";
}

createModuleFiles();

#
# generate the test files if necessary
#
if(!-e $moduleName."/tests") {
    mkdir $moduleName."/tests";
} else {
    print "The test directory already exists, checking for test file ...\n";
    if(!-e "$moduleName/tests/$testFileName") {
        createTestFile();
    } else {
        print "The test file exists.  Moving on...\n";
    }
}

#
# look for hook_simpletest in the module file, if it doesn't exist, insert it.
#
if(!-e "$moduleName/$moduleFileName") {
    die "for some reason, the module file disappeared.  I didn't do it!\n"
}
tie @moduleFile, 'Tie::File', "$moduleName/$moduleFileName" or
    die "Can't open $moduleName/$moduleFileName : $!";

my $element = first { /^\s*function ($moduleName)_simpletest\(/ } @moduleFile;
if(defined($element)) {
} else {
    print "the function 'hook_simpletest() was not found in the module file."
      . " Adding it now...\n";
    my $insert = getInsertIndex($moduleName, @moduleFile);
    $moduleFile[$insert] .= "\n\n$simpletest \n";
}
untie @moduleFile;

#
# cull class/method/function info from the module file
#
print "processing $moduleFileName ...\n";
tie @moduleFile, 'Tie::File', "$moduleName/$moduleFileName" or
    die "Can't open $moduleName/$moduleFileName : $!";

$inClass = 0;
foreach my $line (@moduleFile) {
    if($line =~ m/^\s*class\s*(\w*)\s*\{/ && $inClass == 0) {
    # beginning of a class def
        $rec = {};
        $rec->{NAME} = $1;
        $inClass = 1;
        print $tab."processing class: $1...\n";
    } elsif ($line =~ m/^\s*private\s*\$(\w*)\;/ && $inClass == 1) {
    # a private attribute
        push @{$rec->{ATTRIBS}}, $1;
    } elsif ($line =~ 
        m/^\s*private|protected|public\s*\w*\s*function\s(\w*)\(/
        && $inClass == 1) {
    # instance/class methods, ignore __construct and other magic functions
        if(!($1 =~ m/^__/)) {
            push @{$rec->{METHODS}}, $1;
        }
    } elsif ($line =~ m/^\s*function\s(\w*)\(/ && $inClass == 0) {
    # functions defined outside of any classes
        push(@funcs, $1);
    } elsif($line =~ m/^\}/ && $inClass == 1) {
    # end of class def
        $inClass = 0;
        push @classes, $rec;
        print $tab."finished processing class: $rec->{NAME}\n\n";
        undef @attribs;
        undef @methods;
    }
}
untie @moduleFile;

#
# TODO: create/update the getter/setter methods for private attributes
#

#
# TODO: create an array of the classes to search for and generalize the next
# section
#
my @testClasses;
foreach $class (@classes) {
    push(@testClasses, $class->{NAME});
}
push(@testClasses, $moduleName);

if(@testClasses == 0) {
    print "No Classes found.\n";
} else {
    print "Found the following classes:\n";
    foreach(@testClasses) {
        print "$tab - $_\n";
    }
}

#
# search for the function in the test file.  If it already exists, remove it
# from the search list, @funcs
# We're not handling removal of methods/functions yet: want to be as
# non-destructive as possible
#
if(!-e "$moduleName/tests/$testFileName") {
    createTestFile();
}
tie @testFile, 'Tie::File', "$moduleName/tests/$moduleName.test" or
    die "Can't open $moduleName/$moduleName.test : $!";

foreach my $func (@funcs) {
    my $element = first { /^\s*public function test_$func/ } @testFile;
    if(!defined($element)) {
        push(@newFuncs, $func);
    }
}

#
# Update the test file with new classes and functions
#
my $insert = -1;
$insert = getInsertIndex($moduleName, @testFile);

if($insert == -1) {
    die "something went horribly wrong, I couldn't find the insert point for".
        " $moduleName in $testFileName.\n";
}

if(@newFuncs == 0) {
    print "no new functions found\n";
} else {
    print "found the following new functions:\n";
    foreach(@newFuncs) {
        print "$tab - $_\n";
    }
    print "we will insert new code at line $insert\n";
    foreach(@newFuncs) {
        $testFile[$insert] .= "\n\n" . createFuncTestStub($_);
    }
# save this code for when we generalize it to handle class defs
#    foreach my $class (@classes) {
#        foreach my $attrib (@{$class->{ATTRIBS}}) {
#            print "$attrib\n";
#        }
#        foreach my $meth (@{$class->{METHODS}}) {
#            print "$meth\n";
#        }
#    }
}
untie @testFile;
print "Done processing $moduleName module!\n";
