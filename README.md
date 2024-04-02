## Commands

### php-cs-fixer

```console
php-cs-fixer fix <source-dir> --rules='{"@Symfony": true, "method_chaining_indentation": true, "array_indentation": true, "binary_operator_spaces": {"align_double_arrow": true}, "method_argument_space": {"ensure_fully_multiline": true}, "braces": {"position_after_control_structures": "next"}}'
```

### clang-tidy

```console
clang-tidy <source-files> -fix -checks="*" -- $ARCHFLAGS
clang-format -i -style=file **/*.{c,h}
```
