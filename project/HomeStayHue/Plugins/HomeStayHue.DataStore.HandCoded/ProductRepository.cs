using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using HomeStayHue.CoreBusiness.Models;
using HomeStayHue.UseCases.PluginInterfaces.DataStore;

namespace HomeStayHue.DataStore.HandCoded
{
    public class ProductRepository : IProductRepository, IRoomRepository
    {
        private readonly List<Product> products = new List<Product>();

        public ProductRepository() 
        {
            products = new List<Product>
            {  
                new Product 
                { 
                    Id = 1, 
                    Brand = "Homestay Huế", 
                    Name = "Phòng Nhà Rường Cổ Điển (HH-101)", 
                    Price = 700000, 
                    ImageLink = "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=600&auto=format&fit=crop&q=80", 
                    Description = "Không gian gỗ mít truyền thống đặc trưng Cố Đô Huế, view sân vườn hoa thanh tịnh. Miễn phí trà Cung Đình đón tiếp, bồn tắm ngâm sỏi và wifi tốc độ cao." 
                },
                new Product 
                { 
                    Id = 2, 
                    Brand = "Homestay Huế", 
                    Name = "Phòng Nhà Rường Cổ Điển (HH-102)", 
                    Price = 700000, 
                    ImageLink = "https://images.unsplash.com/photo-1590490360182-c33d57733427?w=600&auto=format&fit=crop&q=80", 
                    Description = "Thiết kế mộc mạc cổ kính, hiên ngắm hoa cau ngát hương. Trang bị đầy đủ điều hòa, máy sấy tóc, bàn làm việc và ấm siêu tốc." 
                },
                new Product 
                { 
                    Id = 3, 
                    Brand = "Ven Sông Hương", 
                    Name = "Phòng Gác Mái Sông Hương (HH-201)", 
                    Price = 900000, 
                    ImageLink = "https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=600&auto=format&fit=crop&q=80", 
                    Description = "Thiết kế gác lửng thoáng đãng, ban công ngắm hoàng hôn và phong cảnh bờ sông Hương. Kèm máy pha cà phê thủ công và Smart TV." 
                },
                new Product 
                { 
                    Id = 4, 
                    Brand = "Ven Sông Hương", 
                    Name = "Phòng Gác Mái Sông Hương (HH-202)", 
                    Price = 900000, 
                    ImageLink = "https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=600&auto=format&fit=crop&q=80", 
                    Description = "Không gian lãng mạn dành cho cặp đôi, cửa sổ mái kính đón ánh sáng tự nhiên. View vườn cây ăn quả xanh mát." 
                },
                new Product 
                { 
                    Id = 5, 
                    Brand = "Khu Biệt Lập", 
                    Name = "Villa Gia Đình Hương Giang (HH-301)", 
                    Price = 1800000, 
                    ImageLink = "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=600&auto=format&fit=crop&q=80", 
                    Description = "Biệt thự mini biệt lập dành cho gia đình hoặc nhóm 6 khách, có bếp nấu đầy đủ tiện nghi, sân nướng BBQ ngoài trời và 2 phòng tắm riêng." 
                },
                new Product 
                { 
                    Id = 6, 
                    Brand = "Khu Sinh Thái", 
                    Name = "Bungalow Vườn Trúc Xanh (HH-401)", 
                    Price = 850000, 
                    ImageLink = "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=600&auto=format&fit=crop&q=80", 
                    Description = "Bungalow giữa rặng trúc xanh mát, hiên thưởng trà đọc sách yên tĩnh. Thích hợp cho du khách yêu thiên nhiên và phong cách nghỉ dưỡng tĩnh tâm." 
                }
            };
        }

        public Product? GetProduct(int id)
        {
            return products.FirstOrDefault(p => p.productId == id);
        }

        public IEnumerable<Product> GetProducts(string? filter = null)
        {
            if (string.IsNullOrWhiteSpace(filter)) return products;

            return products.Where(p => !string.IsNullOrEmpty(p.Name) && (p.Name.Contains(filter, StringComparison.OrdinalIgnoreCase) || p.Description.Contains(filter, StringComparison.OrdinalIgnoreCase)));
        }

        public IEnumerable<Room> GetAvailableRooms(int roomTypeId, DateTime checkIn, DateTime checkOut)
        {
            return products.Select(p => new Room { Id = p.Id, Name = p.Name, Brand = p.Brand, Price = p.Price, Description = p.Description, ImageLink = p.ImageLink });
        }
    }
}
