<?php
if(!defined('IN_DISCUZ')) {
	exit('Access Denied');
}
/**
 * 导航设置 
 * C::m('#ankixmis#ankixmis_nav_setting')->get()
 **/
class model_ankixmis_nav_setting
{
    private $cfgkey = "ankixmis_navmenu";

	// 获取默认配置
    public function get_default_setting()
    {
        $setting = array (
            // 导航菜单
            'navmenu' => array (
                array('newtab'=>0,'enable'=>1,'text'=>'车辆采购','icon'=>'fa fa-product-hunt','href'=>'#/',
                      'subitems' => array (
                        array('newtab'=>0,'enable'=>1,'text'=>'预算管理','icon'=>'fa fa-cny','href'=>'#/budget'),
                        array('newtab'=>0,'enable'=>1,'text'=>'PR单管理','icon'=>'icon icon-reply','href'=>'#/pr'),
                        array('newtab'=>0,'enable'=>1,'text'=>'PO单管理','icon'=>'icon icon-check','href'=>'#/po'),
                )), 
                array('newtab'=>0,'enable'=>1,'text'=>'商品&供应商','icon'=>'sicon-users','href'=>'#/',
                      'subitems' => array (
                        array('newtab'=>0,'enable'=>1,'text'=>'商品管理','icon'=>'fa fa-caret-right','href'=>'#/material'),
                        array('newtab'=>0,'enable'=>1,'text'=>'供应商管理','icon'=>'fa fa-caret-right','href'=>'#/supplier'),
                )), 
                array('newtab'=>0,'enable'=>0,'text'=>'库存管理','icon'=>'fa fa-car','href'=>'#/',
                      'subitems' => array (
                        array('newtab'=>0,'enable'=>1,'text'=>'车辆管理','icon'=>'fa fa-caret-right','href'=>'#/car'),
                )),
            )
        );
		return $setting;
    }

    // 获取配置
    public function get() 
    {/*{{{*/
        $setting = $this->get_default_setting();
        global $_G;
        $cfgkey = $this->cfgkey;
        if (isset($_G['setting'][$cfgkey])) {
            $config = unserialize($_G['setting'][$cfgkey]);
            foreach ($setting as $k => &$v) {
                if (isset($config[$k])) {
                    $v = $config[$k];
                }
            }
        }
        return $setting;
    }/*}}}*/

    // 获取启用的导航菜单列表
    public function getEnabledNavMenu()
    {/*{{{*/
        $nav = $this->get();
        $res = array();
        foreach ($nav['navmenu'] as $im) {
            if ($im['enable']!=1) continue;
            $navItem = array (
                'icon' => $im['icon'],
                'text' => $im['text'],
                'href' => $im['href'],
                'newtab' => $im['newtab'],
                'subitems' => array(),
            );
            if (!empty($im['subitems'])) {
                foreach ($im['subitems'] as $sim) {
                    if ($sim['enable']!=1) continue;
                    $navItem['subitems'][] = eps_utils::getvalues($sim,array('icon','text','href','newtab'));
                }
            }
            $res[] = $navItem;
        }
        return $res;
    }/*}}}*/

    // 恢复默认配置
    public function reset()
    {
        C::t('common_setting')->delete($this->cfgkey);
        updatecache('setting');
    }

    // 保存配置
    public function set(&$setting)
    {
        C::t('common_setting')->update($this->cfgkey,$setting);
        updatecache('setting');
    }
	
}
// vim600: sw=4 ts=4 fdm=marker syn=php
?>
