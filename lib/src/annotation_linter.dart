import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:ssword/src/linter/internal.dart';

class AnnotationLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [AtInternalRule()];
}
