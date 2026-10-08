using HomeStayHue.CoreBusiness.Models;
using System.Collections.Generic;

namespace HomeStayHue.UseCases.PluginInterfaces.DataStore
{
    public interface IRoomRepository : IProductRepository
    {
        IEnumerable<Room> GetAvailableRooms(int roomTypeId, System.DateTime checkIn, System.DateTime checkOut);
    }
}
