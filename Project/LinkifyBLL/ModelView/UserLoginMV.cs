using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LinkifyBLL.ModelView
{
    public class UserLoginMV
    {
        [Required(ErrorMessage = "Enter Your Email")]
        public string Email { get; set; }
        [Required(ErrorMessage = "Enter the Password")]
        public string? Password { get; set; }
    }
}
