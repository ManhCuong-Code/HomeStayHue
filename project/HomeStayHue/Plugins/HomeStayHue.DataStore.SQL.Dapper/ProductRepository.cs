using System;
using System.Collections.Generic;
using System.Linq;
using HomeStayHue.CoreBusiness.Models;
using HomeStayHue.UseCases.PluginInterfaces.DataStore;

namespace HomeStayHue.DataStore.SQL.Dapper
{
    public class ProductRepository : IProductRepository, IRoomRepository
    {
        private readonly IDataAccess _dataAccess;

        public ProductRepository(IDataAccess dataAccess)
        {
            _dataAccess = dataAccess;
        }

        public Product? GetProduct(int id)
        {
            string sql = @"SELECT ProductId as Id, Brand, Name, Price, ImageLink, Description 
                           FROM [dbo].[Product] 
                           WHERE ProductId = @ProductId;";

            return _dataAccess.QuerySingle<Product, dynamic>(sql, new { ProductId = id });
        }

        public IEnumerable<Product> GetProducts(string? filter = null)
        {
            string sql = @"SELECT ProductId as Id, Brand, Name, Price, ImageLink, Description 
                           FROM [dbo].[Product] 
                           WHERE @Filter IS NULL 
                              OR TRIM(@Filter) = '' 
                              OR LOWER(Name) LIKE '%' + LOWER(@Filter) + '%' 
                              OR LOWER(Brand) LIKE '%' + LOWER(@Filter) + '%';";

            return _dataAccess.Query<Product, dynamic>(sql, new { Filter = filter });
        }

        public IEnumerable<Room> GetAvailableRooms(int roomTypeId, DateTime checkIn, DateTime checkOut)
        {
            return GetProducts().Select(p => new Room 
            { 
                Id = p.Id, 
                Name = p.Name, 
                Brand = p.Brand, 
                Price = p.Price, 
                Description = p.Description, 
                ImageLink = p.ImageLink 
            });
        }
    }
}