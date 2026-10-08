using System;

namespace HomeStayHue.UseCases.PluginInterfaces.StateStore
{
    public interface IStateStore
    {
        void AddStateChangeListeners(Action listeners);
        void RemoveStateChangeListeners(Action listeners);
        void BroadCastStateChange();
    }
}
