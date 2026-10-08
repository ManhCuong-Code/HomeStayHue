using HomeStayHue.CoreBusiness.Models;
using System.Collections.Generic;

namespace HomeStayHue.UseCases.SearchRoomScreen
{
    public interface ISearchRoomUseCase
    {
        IEnumerable<Product> Execute(string? filter = null);
    }
}
