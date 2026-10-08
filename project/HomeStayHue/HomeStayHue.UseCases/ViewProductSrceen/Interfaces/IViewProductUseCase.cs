using HomeStayHue.CoreBusiness.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace HomeStayHue.UseCases.ViewProductSrceen.Interfaces
{
    public interface IViewProductUseCase
    {
        Product? Execute(int id);
    }
}
