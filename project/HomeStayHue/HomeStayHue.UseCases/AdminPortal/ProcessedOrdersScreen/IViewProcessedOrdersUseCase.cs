using System.Collections.Generic;
using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.AdminPortal.ProcessedOrdersScreen
{
    public interface IViewProcessedOrdersUseCase
    {
        IEnumerable<Order> Execute();
    }
}