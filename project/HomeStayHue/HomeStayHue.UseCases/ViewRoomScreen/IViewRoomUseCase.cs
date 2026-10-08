using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.ViewRoomScreen
{
    public interface IViewRoomUseCase
    {
        Product? Execute(int id);
    }
}
