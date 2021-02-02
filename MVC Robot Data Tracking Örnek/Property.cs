using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace Robot_Tracking.Models.Class
{
    public class Property
    {
        [Key]
        public int Id { get; set; }
        public int MacState { get; set; }
        public int UnitState { get; set; }
        public bool MacStatus { get; set; }
        public int MacATime { get; set; }
        public int MacSTime { get; set; }
        public int MacETime { get; set; }
        public DateTime Date { get; set; }
        public virtual Robot Robot { get; set; }
        public ICollection<Time> Times { get; set; }


    }
}