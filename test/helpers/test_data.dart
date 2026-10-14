import 'package:clothing_store/features/auth/domain/entities/user.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';

// Image paths start with "assets/" so widget tests never hit the network.
const tShirt = Product(
  id: 'p1',
  name: 'Everyday Tee',
  subtitle: 'Organic cotton',
  price: 500,
  imageUrl: 'assets/test/none.png',
  category: 'T-Shirts',
);

const tJeans = Product(
  id: 'p2',
  name: 'Mom Jeans',
  subtitle: 'Vintage wash',
  price: 1500,
  imageUrl: 'assets/test/none.png',
  category: 'Jeans',
);

const tUser = User(id: 'u_001', email: 'demo@shop.com', name: 'Demo User');
