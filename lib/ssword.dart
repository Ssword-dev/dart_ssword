library;

import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:ssword/src/linter.dart';

// the linter for annotations declared in src/annotations (using custom_linter)
export 'linter.dart';
export 'annotations.dart';

/// For custom_lint

PluginBase createPlugin() => SswordLinter();
