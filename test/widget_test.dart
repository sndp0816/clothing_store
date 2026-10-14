import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clothing_store/features/products/presentation/widgets/product_card.dart';

import 'helpers/test_data.dart';

void main() {
  testWidgets('ProductCard shows product info and fires its callbacks', (tester) async {
    var favouriteTaps = 0;
    var addTaps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 220,
              height: 330,
              child: ProductCard(
                product: tShirt,
                isFavourite: false,
                quantityInCart: 0,
                onFavouriteToggle: () => favouriteTaps++,
                onAddToCart: () => addTaps++,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Everyday Tee'), findsOneWidget);
    expect(find.text('₹500'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.tap(find.text('Add to Cart'));

    expect(favouriteTaps, 1);
    expect(addTaps, 1);
  });
}
