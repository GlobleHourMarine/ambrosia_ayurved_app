import 'package:flutter/material.dart';

class ProductSpecificationsSection extends StatefulWidget {
  const ProductSpecificationsSection({super.key});

  @override
  State<ProductSpecificationsSection> createState() =>
      _ProductSpecificationsSectionState();
}

class _ProductSpecificationsSectionState
    extends State<ProductSpecificationsSection> {
  int _expandedIndex =
      -1; // -1 means none expanded, 0 for ingredients, 1 for additional info

  final GlobalKey _ingredientsKey = GlobalKey();
  final GlobalKey _additionalInfoKey = GlobalKey();

  void _toggleExpansion(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? -1 : index;
    });

    // After the section expands, smoothly scroll to make it visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_expandedIndex == index) {
        final context = index == 0
            ? _ingredientsKey.currentContext
            : _additionalInfoKey.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment:
                0.1, // Align to 10% from top (so it's not exactly at the top)
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCombinedSectionHeader(),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            //  color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Ingredient List Section
                KeyedSubtree(
                  key: _ingredientsKey,
                  child: _buildCombinedSectionItem(
                    index: 0,
                    title: 'Ingredient List',
                    icon: Icons.eco_rounded,
                    iconColor: Colors.green[700]!,
                    content: _buildIngredientContent(),
                  ),
                ),

                // Divider between sections
                const Divider(height: 1, thickness: 1),

                // Additional Information Section
                KeyedSubtree(
                  key: _additionalInfoKey,
                  child: _buildCombinedSectionItem(
                    index: 1,
                    title: 'Additional Information',
                    icon: Icons.info_outline_rounded,
                    iconColor: Colors.green[700]!,
                    content: _buildAdditionalInfoContent(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCombinedSectionHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
      ),
      child: const Text(
        'PRODUCT SPECIFICATIONS',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCombinedSectionItem({
    required int index,
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget content,
  }) {
    bool isExpanded = _expandedIndex == index;

    return Column(
      children: [
        // Section Header
        ListTile(
          leading: Icon(icon, color: iconColor, size: 24),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 102, 172, 105),
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.grey[600],
            size: 24,
          ),
          onTap: () => _toggleExpansion(index),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),

        // Expandable Content
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: content,
          ),
      ],
    );
  }

  Widget _buildIngredientContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INGREDIENTS:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Text('Tinospora cordifolia (Giloy)'),
          Text('Azadirachta indica (Neem)'),
          Text('Trigonella foenum-graecum (Fenugreek)'),
          Text('Gymnema sylvestre (Gurmar)'),
          Text('Salacia chinensis (Salacia)'),
          Text('Pterocarpus marsupium (Indian Kino Tree / Vijaysar)'),
          Text('Alpinia galanga (Greater Galangal)'),
          Text('Cedrus deodara (Deodar Cedar / Himalayan Cedar)'),
          Text('Momordica charantia (Bitter Gourd / Bitter Melon)'),
          Text('Terminalia bellirica (Beleric / Baheda)'),
          Text('Phyllanthus emblica (Indian Gooseberry / Amla)'),
          Text('Asparagus racemosus (Shatavari / Wild Asparagus)'),
          Text('Glycyrrhiza glabra (Licorice / Mulethi)'),
          Text('Tribulus terrestris (Puncture Vine / Gokshura)'),
          Text('Withania somnifera (Ashwagandha / Indian Ginseng)'),
          Text('Moringa oleifera (Drumstick Tree / Moringa)'),
          Text('Siraitia grosvenorii (Monk Fruit / Luo Han Guo)'),
          Text('Catharanthus (Madagascar Periwinkle)'),
          Text('Sri Lankan Eucalyptus (Sri Lankan Eucalyptus Tree)'),
          Text('Caterpillar Fungus (Cordyceps / Himalayan Viagra)'),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            icon: Icons.inventory_2_outlined,
            title: 'Product Items Name',
            content: 'A5 – Herbal Supplement',
          ),
          const Divider(height: 20),
          _buildInfoRow(
            icon: Icons.description_outlined,
            title: 'Product Description',
            content: '1 Box included 60 Sachets\n1 Box included 24 Bottles',
          ),
          const Divider(height: 20),
          _buildInfoRow(
            icon: Icons.scale_outlined,
            title: 'Quantity',
            content: 'Each Sachet 5 Gram\nEach Bottle 80 ml',
          ),
          const Divider(height: 20),
          _buildInfoRow(
            icon: Icons.business_center_outlined,
            title: 'Brand Name',
            content: 'Ambrosia Ayurved',
          ),
          const Divider(height: 20),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            title: 'Manufacture & Marketer Detail',
            content: 'Ground Floor, Plot no. 1230, ARK Tower, '
                'JLPL Industrial Area, Sector 82 Mohali, '
                'S.A.S Nagar, Punjab - 140306',
          ),
          const Divider(height: 20),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            title: 'Best Before',
            content: '36 Months',
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
    bool isHighlighted = true,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            color: isHighlighted ? Colors.green[700] : Colors.grey[700],
            size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isHighlighted ? Colors.green[700] : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IngredientItem extends StatelessWidget {
  final String name;
  final String quantity;

  const _IngredientItem(this.name, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 8),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            quantity,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
