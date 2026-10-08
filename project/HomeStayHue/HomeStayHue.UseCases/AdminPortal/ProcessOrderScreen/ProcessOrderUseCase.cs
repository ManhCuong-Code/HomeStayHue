using System;
using HomeStayHue.CoreBusiness.Models;
using HomeStayHue.UseCases.PluginInterfaces.DataStore;

namespace HomeStayHue.UseCases.AdminPortal.ProcessOrderScreen
{
    public class ProcessOrderUseCase : IProcessOrderUseCase
    {
        private readonly IOrderRepository _orderRepository;

        public ProcessOrderUseCase(IOrderRepository orderRepository)
        {
            _orderRepository = orderRepository;
        }

        public bool Execute(int orderId, string adminUserName)
        {
            var order = _orderRepository.GetOrder(orderId);
            if (order == null) return false;

            order.AdminUser = adminUserName;
            order.DateProcessed = DateTime.Now;
            _orderRepository.UpdateOrder(order);
            return true;
        }
    }
}