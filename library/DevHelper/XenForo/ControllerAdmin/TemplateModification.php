<?php

class DevHelper_XenForo_ControllerAdmin_TemplateModification extends XFCP_DevHelper_XenForo_ControllerAdmin_TemplateModification
{
	public function actionIndex()
	{
		$response = parent::actionIndex();

		if ($response instanceof XenForo_ControllerResponse_View)
		{
			$addOns = &$response->params['addOns'];
			$groupedModifications = &$response->params['groupedModifications'];
			$modificationCount = &$response->params['modificationCount'];

			$modificationCount -= $this->getHelper('DevHelper_ControllerHelper_AddOn')->filterKeepActiveAddOns($groupedModifications, $addOns);
		}

		return $response;
	}

}
