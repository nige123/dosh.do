### multi sub MAIN

```raku
multi sub MAIN(
    *@args
) returns Mu
```

Prompt an LLM with a natural language request for a shell command. Only execute the command if confirmed.

### multi sub MAIN

```raku
multi sub MAIN(
    "help"
) returns Mu
```

show this help

### multi sub MAIN

```raku
multi sub MAIN(
    "config"
) returns Mu
```

configure defaults

### multi sub MAIN

```raku
multi sub MAIN(
    "version"
) returns Mu
```

show the version

