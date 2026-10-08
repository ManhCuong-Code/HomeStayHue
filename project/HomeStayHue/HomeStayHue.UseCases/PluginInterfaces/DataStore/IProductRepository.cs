using System;
using System.Collections.Generic;
using System.Text;
using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.PluginInterfaces.DataStore
{
    public interface IProductRepository
    {
        IEnumerable<Product> GetProducts(string? filter = null);
        Product? GetProduct(int id);
    }
}
