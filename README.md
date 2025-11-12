# dosh (DO SHell)

LLM-powered utility for requesting and executing shell commands. 

Make a request using natural language and **dosh** prompts an LLM for a shell command to fulfil your request. 

It's OK to feel shy about executing the suggested command.

The command will not execute without your confirmation. Please be careful when confirming. 

## Usage
```
    shell> dosh ask for what you want              -- in natural language
    
    shell> dosh what processes are using the most memory 
    shell> dosh how much disk space is left
    shell> dosh what programs have ports open
    shell> dosh remove .tmp files larger than 100 meg 
    
    shell> dosh config                             -- change LLM settings
    shell> dosh help                               -- show this help
```

## Install

**dosh** is a Raku command-line utility.

1. Install Raku

    [https://raku.org/downloads/](https://raku.org/downloads/)

2. Install dosh 
    
    ```
    shell> zef install dosh
    ```
3. Set up your LLM with LLM::DWIM

    ```
    shell> rakudoc LLM::DWIM
    ```
