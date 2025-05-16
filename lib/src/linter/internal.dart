import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AtInternalRule extends DartLintRule {
  AtInternalRule()
    : super(
        code: LintCode(
          name: "at_internal",
          problemMessage:
              "Elements marked @internal can only be used in the same file they were declared.",
        ),
      );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addSimpleIdentifier((SimpleIdentifier node) {
      final Element? element = node.staticElement;
      if (element == null) return;

      if (element is! ExecutableElement &&
          element is! VariableElement &&
          element is! ClassElement) {
        return;
      }

      final isInternal = element.metadata.any(
        (annotation) =>
            annotation.element?.name == 'internal' ||
            annotation.element?.enclosingElement3?.displayName == 'internal',
      );

      if (!isInternal) return;

      final usedAt =
          node
              .thisOrAncestorOfType<CompilationUnit>()
              ?.declaredElement
              ?.source
              .fullName;
      final declaredAt = element.declaration?.source?.fullName;

      if (usedAt != null && declaredAt != null && usedAt != declaredAt) {
        reporter.atNode(node, code);
      }
    });
  }
}
