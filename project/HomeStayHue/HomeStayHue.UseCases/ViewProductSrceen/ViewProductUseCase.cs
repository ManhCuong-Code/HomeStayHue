using System;
using System.Collections.Generic;
using System.Text;
using HomeStayHue.CoreBusiness.Models;
using HomeStayHue.UseCases.PluginInterfaces.DataStore;
using HomeStayHue.UseCases.ViewProductSrceen.Interfaces;

namespace HomeStayHue.UseCases.ViewProductSrceen
{
    public class ViewProductUseCase : IViewProductUseCase
    {
        private readonly IProductRepository productRepository;
        public ViewProductUseCase(IProductRepository productRepository)
        {
            this.productRepository = productRepository;
        }
        public Product? Execute(int id)
        {
            return productRepository.GetProduct(id);
        }
    }
}
