import 'package:doanthuchanh/Page/SanPham/ChiTiet.dart';
import 'package:doanthuchanh/data/api.dart';
import 'package:doanthuchanh/data/sqlite.dart';
import 'package:doanthuchanh/model/cart.dart';
import 'package:doanthuchanh/model/category.dart';
import 'package:doanthuchanh/model/favourite.dart';
import 'package:doanthuchanh/model/product.dart';
import 'package:doanthuchanh/value/app_color.dart';
import 'package:doanthuchanh/value/app_font.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trangchu2 extends StatefulWidget {
  const Trangchu2({Key? key}) : super(key: key);

  @override
  State<Trangchu2> createState() => _Trangchu2State();
}

class _Trangchu2State extends State<Trangchu2> {
  final DatabaseHelper _databaseService = DatabaseHelper();

  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountId = prefs.getString('accountID') ?? '';
    String token = prefs.getString('token') ?? '';
    return await APIRepository().getProduct(accountId, token);
  }

  Future<List<CategoryModel>> _getCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountId = prefs.getString('accountID') ?? '';
    String token = prefs.getString('token') ?? '';
    return await APIRepository().getCategory(accountId, token);
  }

  Future<void> _onSave(ProductModel pro) async {
    await _databaseService.insertProduct(
      Cart(
        productID: pro.id,
        name: pro.name,
        des: pro.description,
        price: pro.price,
        img: pro.imageUrl,
        count: 1,
      ),
    );
    setState(() {});
  }

  Future<void> _onSavF(ProductModel pro) async {
    await _databaseService.insertProductf(
      Favourite(
        productID: pro.id,
        name: pro.name,
        des: pro.description,
        price: pro.price,
        img: pro.imageUrl,
        count: 1,
      ),
    );
    setState(() {});
  }

// Hàm tìm kiếm sản phẩm

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            color: Color.fromARGB(255, 139, 198, 250),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'HL Mobile',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/ip15banner.jpg'),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Danh mục sản phẩm',
                  style: AppStyles.h4.copyWith(color: Colors.blue),
                ),
              ),
            ],
          ),
          // FutureBuilder cho danh mục
          FutureBuilder<List<CategoryModel>>(
            future: _getCategory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                return Container(
                  height: 150, // Chiều cao cụ thể cho ListView
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final itemCategory = snapshot.data![index];
                      return DanhMuc(itemCategory, context);
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('No categories available'),
                );
              }
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Sản phẩm',
                style: AppStyles.h4.copyWith(color: Colors.blue),
              ),
            ),
          ),
          // Hiển thị danh sách sản phẩm
          FutureBuilder<List<ProductModel>>(
            future: _getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Số cột trong lưới
                    crossAxisSpacing: 10.0, // Khoảng cách giữa các cột
                    mainAxisSpacing: 10.0, // Khoảng cách giữa các hàng
                    childAspectRatio: 0.7, // Tỉ lệ khung hình của các mục
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final itemProduct = snapshot.data![index];
                    return SanPhamWidget(pro: itemProduct);
                  },
                );
              } else {
                return const Center(
                  child: Text('No products available'),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget DanhMuc(CategoryModel cate, BuildContext build) {
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(cate.imageUrl),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            cate.name,
            style: AppStyles.h5.copyWith(
                color: Color.fromARGB(255, 42, 109, 163),
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class SanPhamWidget extends StatefulWidget {
  final ProductModel pro;
  const SanPhamWidget({Key? key, required this.pro}) : super(key: key);

  @override
  _SanPhamWidgetState createState() => _SanPhamWidgetState();
}

class _SanPhamWidgetState extends State<SanPhamWidget> {
  final DatabaseHelper _databaseService = DatabaseHelper();
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavourite();
  }

  Future<void> _checkIfFavourite() async {
    List<Favourite> favourites = await _databaseService.productsf();
    for (var fav in favourites) {
      if (fav.productID == widget.pro.id) {
        setState(() {
          isFavourite = fav.count > 0;
        });
        break;
      }
    }
  }

  Future<void> _toggleFavourite(ProductModel pro) async {
    if (isFavourite) {
      // Xóa khỏi yêu thích
      Favourite? fav = await _databaseService.getFavouriteById(pro.id);
      if (fav != null && fav.count > 1) {
        fav.count--;
        await _databaseService.updateFavourite(fav);
      } else {
        await _databaseService.deleteProductf(pro.id);
      }
    } else {
      // Thêm vào yêu thích
      Favourite newFavourite = Favourite(
        productID: pro.id,
        name: pro.name,
        des: pro.description,
        price: pro.price,
        img: pro.imageUrl,
        count: 1,
      );
      await _databaseService.insertProductf(newFavourite);
    }
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  Future<void> _onSave(ProductModel pro) async {
    await _databaseService.insertProduct(
      Cart(
        productID: pro.id,
        name: pro.name,
        des: pro.description,
        price: pro.price,
        img: pro.imageUrl,
        count: 1,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Chitiet(sp: widget.pro)));
        },
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hiển thị hình ảnh sản phẩm
                if (widget.pro.imageUrl != null &&
                    widget.pro.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Image.network(
                          widget.pro.imageUrl,
                          height: 100,
                          // width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                // Hiển thị tên sản phẩm
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.pro.name,
                        style: AppStyles.h5.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 1, 34, 61)),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavourite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _toggleFavourite(widget.pro),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                // Hiển thị giá sản phẩm
                Text(
                  'Giá: ${widget.pro.price.toString()} VND',
                  style: AppStyles.h6.copyWith(color: Colors.red),
                ),
                SizedBox(height: 10),
                // Nút thêm vào giỏ hàng
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _onSave(widget.pro),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Thêm vào giỏ hàng',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
