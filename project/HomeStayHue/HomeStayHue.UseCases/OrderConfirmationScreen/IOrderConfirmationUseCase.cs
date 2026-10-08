using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.OrderConfirmationScreen
{
    public interface IOrderConfirmationUseCase
    {
        Order? Execute(string uniqueId);
    }
}