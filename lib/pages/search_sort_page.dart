import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constant.dart';
import 'package:grocery_app/models/products.dart';
import 'package:grocery_app/widget/cart_item_widget.dart';

enum SortOption { nameAZ, priceLowToHigh, priceHighToLow }

class SearchSortPage extends StatefulWidget {
  const SearchSortPage({super.key});

  @override
  State<SearchSortPage> createState() => _SearchSortPageState();
}

class _SearchSortPageState extends State<SearchSortPage> {
  final TextEditingController searchController = TextEditingController();

  List<Products> allItems = [];
  List<Products> filteredItems = [];
  SortOption _currentSort = SortOption.nameAZ;

  @override
  void initState() {
    super.initState();

    allItems = List.from(items);

    filteredItems = List.from(allItems);
  }

  void onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = List.from(allItems);
      } else {
        filteredItems = allItems
            .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      _applySort();
    });
  }

  void _applySort() {
    switch (_currentSort) {
      case SortOption.nameAZ:
        filteredItems.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.priceLowToHigh:
        filteredItems.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        filteredItems.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sort By", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildSortTile("Name (A-Z)", SortOption.nameAZ),
              _buildSortTile("Price (Low to High)", SortOption.priceLowToHigh),
              _buildSortTile("Price (High to Low)", SortOption.priceHighToLow),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortTile(String title, SortOption option) {
    final isSelected = _currentSort == option;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Constant.primaryColor : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: Constant.primaryColor) : null,
      onTap: () {
        setState(() {
          _currentSort = option;
          _applySort();
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.shade100,
          ),
          child: TextField(
            controller: searchController,
            onChanged: onSearch,
            autofocus: true,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 22),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                      onPressed: () {
                        searchController.clear();
                        onSearch('');
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
              hintText: "Search groceries...",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: _showSortOptions,

              icon: const Icon(Icons.tune, color: Colors.black),
              tooltip: "Sort",
            ),
          ),
        ],
      ),
      body: filteredItems.isEmpty
          ? _buildEmptyState()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "${filteredItems.length} items found",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      // return CartItemWidget(item: filteredItems[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 20),
            Text(
              "No Item Found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We couldn't find '${searchController.text}'",
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
