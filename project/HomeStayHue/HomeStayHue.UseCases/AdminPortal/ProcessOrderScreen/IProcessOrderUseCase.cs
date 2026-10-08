using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.AdminPortal.ProcessOrderScreen
{
    public interface IProcessOrderUseCase
    {
        bool Execute(int orderId, string adminUserName);
    }
}