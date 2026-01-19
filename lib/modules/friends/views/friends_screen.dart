import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF006680);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Friends',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: primaryTeal.withOpacity(0.3)),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search friends...',
                    prefixIcon: Icon(Icons.search, color: primaryTeal),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),


            _buildSectionHeader("Friend Requests", "4"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) => _buildRequestTile(
                context,
                "Sarah Connor",
                "2 Mutual Friends",
                "https://i.pravatar.cc/150?u=sarah",
                primaryTeal,
              ),
            ),

            const Divider(thickness: 1, indent: 20, endIndent: 20),


            _buildSectionHeader("All Friends", "1.2k"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8,
              itemBuilder: (context, index) => _buildFriendTile(
                "User Name $index",
                "Abeokuta, Ogun",
                "https://i.pravatar.cc/150?u=$index",
                primaryTeal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Header Helper
  Widget _buildSectionHeader(String title, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 8),
          Text(count, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  // Friend Request Tile (Confirm/Delete)
  Widget _buildRequestTile(BuildContext context, String name, String sub, String img, Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(img)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _smallButton("Confirm", primary, Colors.white),
                    const SizedBox(width: 10),
                    _smallButton("Delete", const Color(0xFFF2F2F2), Colors.black87),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFriendTile(String name, String loc, String img, Color primary) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: CircleAvatar(radius: 25, backgroundImage: NetworkImage(img)),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(loc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text("Unfriend", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ),
    );
  }

  // Helper for small action buttons
  Widget _smallButton(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}