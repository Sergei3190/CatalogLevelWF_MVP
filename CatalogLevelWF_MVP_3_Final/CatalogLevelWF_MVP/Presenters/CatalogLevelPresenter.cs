using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CatalogLevelWF_MVP.Models;
using CatalogLevelWF_MVP.Views;
using CatalogLevelWF_MVP.Domens;

namespace CatalogLevelWF_MVP.Presenters
{
    public class CatalogLevelPresenter 
    {
        private readonly ICatalogLevelView view;

        private readonly ICatalogLevelModel model;

        private readonly ICatalogLevelDomen domen;

        public CatalogLevelPresenter(ICatalogLevelView _view, ICatalogLevelModel _model, ICatalogLevelDomen _domen)
        {
            view = _view;
            model = _model;
            domen = _domen;
        }

        public void Load_Catalog_Level()
        {
            var catalogLevels = model.Load_Catalog_Levels();
            var treeNodes = domen.AddTreeNodes(catalogLevels);
            view.SetTreeNodes(treeNodes);
        }   
    }
}
