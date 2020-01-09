package Bencher::Scenario::ModuleInstalledTiny::module_source;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;
use warnings;

use File::Path qw(make_path);
use File::Slurper qw(write_text);
use File::Temp qw(tempdir);

my $dir = tempdir(CLEANUP => !$ENV{DEBUG});
@INC = ($dir, @INC);
make_path ("$dir/Bencher/Scenario/ModuleInstalledTiny/module_source");
write_text("$dir/Bencher/Scenario/ModuleInstalledTiny/module_source/Test.pm", "1;");

our $scenario = {
    summary => "Benchmark Module::Installed::Tiny's module_source()",
    participants => [
        # cached version doesn't make any sense for require() because it only
        # checks %INC

        #{
        #    name => 'Module::Installed::Tiny, cached',
        #    module => 'Module::Installed::Tiny',
        #    code_template => 'BEGIN {<begin_code:raw>} Module::Installed::Tiny::module_source(<module>)',
        #    tags => ['cached'],
        #},
        {
            name => 'Module::Installed::Tiny, uncached',
            module => 'Module::Installed::Tiny',
            code_template => 'BEGIN {<begin_code:raw>} delete $INC{<module_pm>}; Module::Installed::Tiny::module_source(<module>)',
            tags => ['uncached'],
        },

        #{
        #    name => 'require, cached',
        #    code_template => 'BEGIN {<begin_code:raw>} require <module_pm>;',
        #    tags => ['cached'],
        #},
        {
            name => 'require, cached',
            code_template => 'BEGIN {<begin_code:raw>} delete $INC{<module_pm>}; require <module_pm>;',
            tags => ['uncached'],
        },
    ],
    datasets => [
        {args=>{module=>'strict', module_pm=>'strict.pm'}, exclude_participant_tags=>['uncached']},
        {args=>{
            module=>'Bencher::Scenario::ModuleInstalledTiny::module_source::Test',
            module_pm=>'Bencher/Scenario/ModuleInstalledTiny/module_source/Test.pm',
            begin_code => "\@INC = ('$dir', \@INC)",
        }, exclude_participant_tags=>['cached']},
    ],
};

1;
# ABSTRACT:

=head1 BENCHMARK NOTES

`module_source()` is slower than `require()` by about 15%.
