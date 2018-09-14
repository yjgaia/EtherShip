// GitHub Pages에서 라우팅 기능을 사용하기 위한 Override

OVERRIDE(URI, (origin) => {
	
	global.URI = METHOD({
	
		run : () => {
			return location.hash.substring(3);
		}
	});
});

OVERRIDE(HREF, (origin) => {
	
	global.HREF = METHOD({
	
		run : (uri) => {
			//REQUIRED: uri
	
			return '#!/' + uri;
		}
	});
});

OVERRIDE(REFRESH, (origin) => {
	
	global.REFRESH = METHOD((m) => {
		
		const REFRESHING_URI = '__REFRESHING';
		
		let getRefreshingURI = m.getRefreshingURI = () => {
			return REFRESHING_URI;
		};
		
		return {
	
			run : (uri) => {
				//OPTIONAL: uri
				
				let savedHash = uri !== undefined ? '#!/' + uri : location.hash;
		
				EVENT_ONCE({
					name : 'hashchange'
				}, () => {
					location.replace(savedHash === '' ? '#!/' : savedHash);
				});
		
				location.href = '#!/' + getRefreshingURI();
			}
		};
	});
});

OVERRIDE(MATCH_VIEW, (origin) => {
	
	global.MATCH_VIEW = METHOD((m) => {
		
		let changeURIHandlers = [];
		let uriData;
		
		let checkAll = m.checkAll = () => {
			EACH(changeURIHandlers, (changeURIHandler) => {
				changeURIHandler();
			});
		};
		
		let setURIData = m.setURIData = (_uriData) => {
			uriData = _uriData;
		};
		
		return {
	
			run : (params) => {
				//REQUIRED: params
				//REQUIRED: params.uri
				//OPTIONAL: params.excludeURI
				//REQUIRED: params.target
	
				let uri = params.uri;
				let excludeURI = params.excludeURI;
				let target = params.target;
				
				let uriMatcher = URI_MATCHER(uri);
				let excludeURIMatcher = excludeURI === undefined ? undefined : URI_MATCHER(excludeURI);
		
				let view;
				let preParams;
				
				let changeURIHandler = () => {
		
					let uri = URI();
					let result;
		
					// when view founded
					if (
					uri !== REFRESH.getRefreshingURI() &&
					(result = uriMatcher.check(uri)).checkIsMatched() === true &&
					(excludeURI === undefined || excludeURIMatcher.check(uri).checkIsMatched() !== true)) {
	
						let uriParams = result.getURIParams();
		
						// when before view not exists, create view.
						if (view === undefined) {
		
							view = target(uriData);
							view.changeParams(uriParams);
							target.lastView = view;
		
							preParams = uriParams;
						}
		
						// when before view exists, change params.
						else if (CHECK_ARE_SAME([preParams, uriParams]) !== true) {
		
							view.changeParams(uriParams);
							preParams = uriParams;
						}
						
						view.runURIChangeHandlers(uri);
						
						DELAY(() => {
							uriData = undefined;
						});
					}
		
					// when view not founded, close before view
					else if (view !== undefined) {
		
						view.close();
		
						view = undefined;
						target.lastView = undefined;
					}
				};
				
				changeURIHandlers.push(changeURIHandler);
				
				EVENT('hashchange', () => {
					changeURIHandler();
				});
				
				changeURIHandler();
			}
		};
	});
});