using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CatalogLevelWF_MVP.Models;
using CatalogLevelWF_MVP.Presenters;
using CatalogLevelWF_MVP.Domens;
using CatalogLevelWF_MVP.Views;

namespace CatalogLevelWF_MVP
{
    public partial class Form1 : Form, ICatalogLevelView
    {
        public Form1()
        {
            InitializeComponent();

            btFillTreeView.Click += delegate
            {
                var presenter = new CatalogLevelPresenter(this, new CatalogLevelModel(), new CatalogLevelDomen());
                presenter.Load_Catalog_Level();
            };

            #region =>
            //btFillTreeView.Click += (sender, e) =>
            //{
            //    var presenter = new CatalogLevelPresenter(this, new CatalogLevelsModel());
            //    presenter.Load_Catalog_Level();
            //};
            #endregion
        }

        void ICatalogLevelView.SetTreeNodes(List<TreeNode> treeNodes)
        {
            treeView.Nodes.Clear();
            DateTime start = DateTime.Now;
            foreach (var item in treeNodes)
            {
                treeView.Nodes.Add(item);
            }
            DateTime finish = DateTime.Now;
            MessageBox.Show($"{finish - start}");
            treeView.ExpandAll();
        }
    } 
}
