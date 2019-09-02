/// This class provides common assertion messages for the [components] library.
class ComponentAssertionMessages {
  static String nullAttributeInData =
      '''An attribute in component's data was missing. 
    A Component's data's class's all attributes should be assigned and not null.''';
  static String nullBuilderMethod = '''The builder method must not be null.''';
  static String nullDataPassedToBuildMethod =
      '''The build method was passed null as the component's data.''';
}
