using System.Threading.Tasks;
using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.PluginInterfaces.DataStore
{
    public interface IUserRepository
    {
        Task<AppUser?> AuthenticateAsync(string username, string password);
        Task<AppUser?> GetByUsernameAsync(string username);
    }
}
