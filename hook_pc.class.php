<?php
if(!defined('IN_DISCUZ')) {
	exit('Access Denied');
}
require_once dirname(__FILE__).'/class/env.class.php';

class plugin_ankixmis
{
    public function common()
    {
		global $_G;
		// 未开启屏蔽其他页面开关
		$setting = C::m('#ankixmis#ankixmis_setting')->get();
		if (!$setting['disable_discuz']) return;
		// 登录页面不屏蔽
		if (strpos($_SERVER['PHP_SELF'],"member.php")!==false && isset($_GET['mod']) && $_GET['mod']=="logging") {
			return;
		}
		// 只允许打开插件页面
		if (strpos($_SERVER['PHP_SELF'],"plugin.php")!==false && isset($_GET['id'])) {
			return;
		}
		// 启用SEO设置的处理
		$ankixmis_url = ankixmis_env::get_siteurl()."/plugin.php?id=ankixmis";
		if (in_array('plugin',$_G['setting']['rewritestatus'])) {
			$ankixmis_url = ankixmis_env::get_siteurl()."/ankixmis-ankixmis.html";
			foreach ($enable_pluginids as $plugin) {
				if (preg_match("/$plugin-[\w]*\.html$/i",$_SERVER['REQUEST_URI'])) {
					return;
				}
			}
		}
		// 跳转到本插件页面
		header("Location: $ankixmis_url");
		exit(0);
    }
}

