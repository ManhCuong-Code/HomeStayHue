using HomeStayHue.CoreBusiness.Models;
using HomeStayHue.UseCases.PluginInterfaces.DataStore;
using System.Collections.Generic;

namespace HomeStayHue.UseCases.SearchRoomScreen
{
    public class SearchRoomUseCase : ISearchRoomUseCase
    {
        private readonly IProductRepository _productRepository;
        public SearchRoomUseCase(IProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        public IEnumerable<Product> Execute(string? filter = null)
        {
            return _productRepository.GetProducts(filter);
        }
    }
}
