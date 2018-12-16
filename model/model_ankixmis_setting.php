<?php
if(!defined('IN_DISCUZ')) {
	exit('Access Denied');
}
/**
 * 插件设置 
 * C::m('#ankixmis#ankixmis_setting')->get()
 **/
class model_ankixmis_setting
{
	// 获取默认配置
    public function getDefault()
    {
		$setting = array (
			// 屏蔽所有discuz页面
			'disable_discuz' => 0,
			// 系统名称
			'page_title' => 'Anki-X-MIS',
			// 版权信息
			'page_copyright' => 'ankixmis.com 2018',
            // 折叠导航菜单
            'fold_navmenu' => 0,
            // 启用缓存
            'cache_enable' => 1,
		);
		return $setting;
    }

    // 获取配置
	public function get()
	{
		$setting = $this->getDefault();
		global $_G;
		if (isset($_G['setting']['ankixmis_config'])){
			$config = unserialize($_G['setting']['ankixmis_config']);
			foreach ($setting as $key => &$item) {
				if (isset($config[$key])) $item = $config[$key];
			}
		}
		return $setting;
	}
}
// vim600: sw=4 ts=4 fdm=marker syn=php
?>
