import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { MyFavourite, All }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = 'ProductOverviewScreen';
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavouriteProduct = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fectAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _showFavouriteProduct
            ? const Text('Your Favourites')
            : const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.MyFavourite) {
                setState(
                  () {
                    _showFavouriteProduct = true;
                  },
                );
              } else {
                setState(
                  () {
                    _showFavouriteProduct = false;
                  },
                );
              }
            },
            itemBuilder: ((context) => [
                  const PopupMenuItem(
                    value: FilterOptions.MyFavourite,
                    child: Text('My Favourite'),
                  ),
                  const PopupMenuItem(
                    value: FilterOptions.All,
                    child: Text('All'),
                  ),
                ]),
            child: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) {
              return Badge(
                child: ch,
              );
            },
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavouriteProduct),
      drawer: const AppDrawer(),
    );
  }
}
