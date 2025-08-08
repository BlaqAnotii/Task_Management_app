import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  final List<String> allCategories;
  final List<String> initiallySelected;

  const CategorySelector({
    Key? key,
    required this.allCategories,
    required this.initiallySelected,
  }) : super(key: key);

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late List<String> selectedCategories;
  late List<String> allCategories; // Local modifiable list
  final TextEditingController newCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCategories = List<String>.from(widget.initiallySelected);
    allCategories = List<String>.from(widget.allCategories); // Make modifiable copy
  }

  void toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  void addNewCategory(String category) {
    if (category.isEmpty || allCategories.contains(category)) return;
    setState(() {
      allCategories.insert(1, category); // Add below "Add new category"
      selectedCategories.add(category);
    });
     ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('New Category Added'),
    backgroundColor: Color.fromARGB(255, 52, 59, 58),
    duration: Duration(seconds: 5),
  ),
);
    newCategoryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                const Text(
                  "Category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Add New Category
            ListTile(
              leading: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  final newCat = newCategoryController.text.trim();
                  addNewCategory(newCat);
                },
              ),
              title: TextFormField(
                controller: newCategoryController,
                decoration: const InputDecoration(
                  hintText: "Add a new category",
                  border: InputBorder.none,
                ),
              ),
            ),

            // Category List
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: allCategories.length,
                itemBuilder: (_, index) {
                  final cat = allCategories[index];
                  return ListTile(
                    title: Text(cat),
                    trailing: Icon(
                      selectedCategories.contains(cat)
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: selectedCategories.contains(cat)
                          ? const Color.fromARGB(255, 52, 59, 58)
                          : Colors.grey,
                    ),
                    onTap: () => toggleCategory(cat),
                  );
                },
              ),
            ),

            // Save Button
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color.fromARGB(255, 52, 59, 58),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(selectedCategories);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
