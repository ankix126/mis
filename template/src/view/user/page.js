define(function(require){
    /* PR单管理 */
    var BasePage = require('core/BasePage');
    var o = new BasePage({
        name : '用户管理',
        id   : 'user',
    });

    // 页面入口
	o.execute = function(domid,query) {
        require('./grid').init(domid,rw);
	};

    return o;
});
