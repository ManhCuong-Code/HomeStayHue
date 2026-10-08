using HomeStayHue.CoreBusiness.Models;
using HomeStayHue.UseCases.PluginInterfaces.DataStore;

namespace HomeStayHue.UseCases.ViewRoomScreen
{
    public class ViewRoomUseCase : IViewRoomUseCase
    {
        private readonly IProductRepository _productRepository;
        public ViewRoomUseCase(IProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        public Product? Execute(int id)
        {
            return _productRepository.GetProduct(id);
        }
    }
}
