using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.AdminPortal.OrderDetailScreen
{
    public interface IViewOrderDetailUseCase
    {
        Order? Execute(int orderId);
    }
}