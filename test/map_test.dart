import 'package:test/test.dart';

Widget createMapScreen() => ChangeNotifierProvider<SimpleMap>(
      create: (context) => SimpleMap(),
      child: MaterialApp(
        home: HomePage(),
      ),
    );

void main{
    group('Map page Widget Tests', (){
        testWidgets('Map should be visible', (tester) async {
            await tester.pumpWidget(createMapScreen());
            expect(find.byType(SimpleMap), findsOneWidget);
        })
    })
}