package Bencher::Scenario::ModuleInstalledTiny;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our $scenario = {
    summary => 'Benchmark Module::Installed::Tiny',
    participants => [
        {
            fcall_template => 'Module::Installed::Tiny::module_installed(<module>)',
        },
        {
            fcall_template => 'Module::Path::More::module_path(module => <module>)',
        },
        {
            fcall_template => 'Module::Load::Conditional::check_install(module => <module>)',
        },
        {
            name => 'require',
            code_template => 'eval { (my $pm = <module> . ".pm") =~ s!::!/!g; require $pm; 1 } ? 1:0',
        },
    ],
    datasets => [
        {args=>{module=>'strict'}},
        #{args=>{module=>'App::Cpan'}}, # an example of a relatively heavy core module to load
        {args=>{module=>'Foo::Bar'}},
    ],
};

1;
# ABSTRACT:
