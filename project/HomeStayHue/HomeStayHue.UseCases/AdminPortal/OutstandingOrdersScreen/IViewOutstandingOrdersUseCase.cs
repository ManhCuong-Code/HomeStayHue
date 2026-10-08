using System.Collections.Generic;
using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.AdminPortal.OutstandingOrdersScreen
{
    public interface IViewOutstandingOrdersUseCase
    {
        IEnumerable<Order> Execute();
    }
}