unit module DOSH::CLI:ver<9.0.0>:auth<zef:nige123>;

use LLM::DWIM;
use JSON::Fast;

# Keep this in sync with META6.json "version"
my constant $VERSION = '9.0.0';

multi sub MAIN('version') is export {
    say $VERSION;
}


#| Prompt an LLM with a natural language request for a shell command. Only execute the command if confirmed.
multi sub MAIN (*@args) is export {
    
    my $spoken-command-request = @args.join(' ');

    return USAGE() unless $spoken-command-request;

    my $prompt = render-prompt();
        
    my $json-data = dwim $prompt ~ ' ' ~ $spoken-command-request;

    if %*ENV{'DOSH_DEBUG'} {
        say "PROMPT:\n" ~ $prompt;
        say "RESPONSE:\n" ~ $json-data;
    }
  
    # handle the response record
    my %llm-response = from-json($json-data);

    my ($explanation, $shell-command, $warning) = %llm-response<explanation shell_command warning>;

    die "No command found." unless $shell-command and $explanation;

    show-header();
    
    say $explanation;
    say "";
    
    if $warning {
        say in-red($warning);
        say "";
    }

    say "\t" ~ in-yellow($shell-command);
    say "";

    my $confirmed = prompt("Do you want to execute the command? (y/N) ");
    say "";

    # IMPORTANT - make sure the user confirms first!
    if $confirmed.uc eq 'Y' or $confirmed.uc eq 'YES' {
        # execute the command with the shell - /sh
        my $p = shell $shell-command;
    }
    else {       
        say in-yellow("Command NOT executed.");
    }
    say "";
    
}

#| show this help
multi sub MAIN ('help') is export {
    USAGE();
}

#| configure defaults
multi sub MAIN ('prompt') is export {
    say render-prompt();
}


#| configure defaults
multi sub MAIN ('config') is export {
    CONFIG();
}

sub CONFIG is export {

    show-header();

    say q:to"CONFIG";
    
    Set the following config to change LLM settings
    
    Config:
    
        See rakudoc LLM::DWIM to swap LLMs. 

        Set the shell environment variables:

        DOSH_DEBUG=1        -- to see the prompt text and raw LLM response.
        DOSH_NO_COLOR=1     -- to remove coloured output.

    CONFIG
}


sub USAGE is export {

    show-header();

    say q:to"USAGE";    

    Make a request using natural language and dosh suggests a shell command to fulfil your request. 
    
    The command will NOT execute without your confirmation. Please be careful when confirming. 

    The command suggestion includes an explanation of what the command does, and a warning if the command will make changes.

    Configure the LLM settings with 'dosh config'.

    Usage:

        shell> dosh ask for what you want              -- in natural language
        
        shell> dosh what processes are using the most memory 
        shell> dosh how much disk space is left
        shell> dosh what programs have ports open
        shell> dosh remove .tmp files larger than 100 meg 
        
        shell> dosh config                             -- change LLM settings
        shell> dosh version                            -- current version
        shell> dosh prompt                             -- show the prompt template
        shell> dosh help                               -- show this help
       
    USAGE
    
}


sub show-header {
    say '';
    say 'dosh (do shell) - LLM-powered shell commands';
    say '____________________________________________';
    say '';
}


sub in-yellow($string) {
    return $string if %*ENV{'DOSH_NO_COLOR'};
    return "\e[33m" ~ $string ~ "\e[0m";
}

sub in-red($string) {
    return $string if %*ENV{'DOSH_NO_COLOR'};
    return "\e[31m" ~ $string ~ "\e[0m";
}

sub in-green($string) { 
    return $string if %*ENV<DOSH_NO_COLOR>; 
    return "\e[32m" ~ $string ~ "\e[0m";
}

sub render-prompt {

    return qq:to"PROMPT";

    You are a senior {$*DISTRO.name} shell engineer on {$*KERNEL.name} {$*KERNEL.release} ({$*KERNEL.hardware}).
    Translate a natural-language request into ONE safe shell command for execution on the {$*VM.osname} operating system.
    
    RESPONSE FORMAT (STRICT):
    Return MINIFIED JSON on a single line, with EXACT keys:
    \{"shell_command":"...","explanation":"...","warning":""\}
    
    RULES:
    - shell_command: a single-line shell command that fully addresses the request.
    - Prefer read-only substitutes (e.g., 'du -sh * | sort -h | tail -n 20') when user intent is unclear.
    - NEVER include sudo unless essential; avoid destructive flags by default.
    - NEVER access external services or APIs; use only local system commands instead.
    - NEVER suggest a command that contains an http:// or https:// URL.
    - explanation: a brief, friendly description of what the command does. 
    - warning: "" if read-only; otherwise 1 short sentence describing the risk.
    - Output ONLY the minified JSON. No prose. No code fences. No backticks.
    
    Examples:
    \{"shell_command":"ls -la","explanation":"Lists files with details in the current directory.","warning":""\}
    \{"shell_command":"find . -type f -size +100M -print0 | xargs -0 ls -lh","explanation":"Shows paths and sizes of files larger than 100 MB.","warning":""\}
    \{"shell_command":"find . -type f -name '*.bak' -delete","explanation":"Deletes all .bak files under the current directory.","warning":"This permanently removes files."\}
    
    The shell_command should solve the following command_request:

    PROMPT
    
}


