using HomeStayHue.CoreBusiness.Models;
using HomeStayHue.UseCases.PluginInterfaces.DataStore;

namespace HomeStayHue.UseCases.OrderConfirmationScreen
{
    public class OrderConfirmationUseCase : IOrderConfirmationUseCase
    {
        private readonly IOrderRepository _orderRepository;

        public OrderConfirmationUseCase(IOrderRepository orderRepository)
        {
            _orderRepository = orderRepository;
        }

        public Order? Execute(string uniqueId)
        {
            return _orderRepository.GetOrderByUniqueId(uniqueId);
        }
    }
}