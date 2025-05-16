import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Implementation of @internal annotation
class AtInternalRule extends DartLintRule {
  AtInternalRule()
    : super(
        code: LintCode(
          name: "at_internal",
          problemMessage:
              "elements declared with mark @internal can only be used in the same file of its declaration!",
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

      // First, check if element is annotated with @internal, else, we dont care
      // so we return early

      final bool isInternal = element.metadata.any((
        ElementAnnotation annotation,
      ) {
        return annotation.element?.name == "internal" ||
            annotation.element?.enclosingElement3?.displayName == "internal";
      });

      if (isInternal) {
        // get the file where this element was declared
        String? declarationFileName = element.declaration?.source?.shortName;
        if (declarationFileName == null) {
          return; // well, we have no source of the declaration to look at so... we cant trace it therefore we return
        }
        String? usedAt = element.source?.shortName;
        if (usedAt == null) {
          return; // again, where we used this is unknown so we return early
        }

        // check if the file that used this element is the same as the file that declares it

        if (declarationFileName != usedAt) {
          reporter.atNode(node, code);
        }
      }
    });
  }
}
