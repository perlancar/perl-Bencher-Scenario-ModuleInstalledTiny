package Bencher::Scenario::ModuleInstalledTiny::module_installed;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;
use warnings;

our $scenario = {
    summary => 'Benchmark module_installed() vs some others',
    description => <<'_',

This scenario benchmarks `module_installed()` vs some others for the task of
checking whether a module "is available locally". There are several approaches
(also described in <pm:Module::Installed::Tiny> documentation):

1. require() it (executes module source code, security and resource concern).

2. find module path in filesystem using Module::Path (cannot handle
hooks/references in @INC; on the other hand does not quickly check %INC first).

3. <pm:Module::Load::Conditional>'s `check_install()`. Like `require()`, it
first checks %INC, then scan @INC (hooks/references in @INC are supported).
Additionally, you can specify a version number, in which case it will also use
<pm:Module::Metadata> to extract version from module source code.

4. <pm:Module::Installed::Tiny>'s `module_installed()`, which also does things
like Perl's `require()` except actually evaluating the module source code.

_
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
        {args=>{module=>'Bencher::Scenario::ModuleInstalledTiny::module_installed::Test'}}, # an example of module that does not exist
    ],
};

1;
# ABSTRACT:
