import 'dart:async';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/home/widgets/post_card.dart';
import 'package:friendzy_social_media_getx/modules/search_post/controllers/search_post_controller.dart';
import 'package:get/get.dart';

class SearchPostScreen extends StatelessWidget {
  SearchPostScreen({super.key});

  final SearchPostController controller = Get.put(SearchPostController());

  Timer? _debounce;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      controller.localSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Post"),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildTopSection(),
          Expanded(
            child: Obx(() {
              if (controller.isSearching.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.posts.isEmpty) {
                return const Center(
                  child: Text(
                    "No posts found",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) =>
                    PostCard(postModel: controller.posts[index]),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: controller.posts.length,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF006680), width: 1),
              ),
              child: TextField(
                autofocus: true,
                controller: controller.searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search something..',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF006680)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.searchController.clear();
                      controller.localSearch();
                    },
                    icon: Icon(Icons.close),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
