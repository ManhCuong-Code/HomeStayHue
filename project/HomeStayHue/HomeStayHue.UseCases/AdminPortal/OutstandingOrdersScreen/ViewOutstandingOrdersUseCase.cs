using System.Collections.Generic;
using HomeStayHue.CoreBusiness.Models;
using HomeStayHue.UseCases.PluginInterfaces.DataStore;

namespace HomeStayHue.UseCases.AdminPortal.OutstandingOrdersScreen
{
    public class ViewOutstandingOrdersUseCase : IViewOutstandingOrdersUseCase
    {
        private readonly IOrderRepository _orderRepository;

        public ViewOutstandingOrdersUseCase(IOrderRepository orderRepository)
        {
            _orderRepository = orderRepository;
        }

        public IEnumerable<Order> Execute()
        {
            return _orderRepository.GetOutstandingOrders();
        }
    }
}