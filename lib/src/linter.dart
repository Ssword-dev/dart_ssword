import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:ssword/src/linter/internal.dart';

// Todo 5/16/2025 Ssword: Add config support
// (json because too much yaml)
/// Ssword's linter, check https://pub.dev/packages/ssword for more info
class SswordLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [AtInternalRule()];
}
